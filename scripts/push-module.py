'''
a script to push qobserve to multiple q-sys cores.
place the urls of your cores in cores.txt one per line - e.g. https://192.168.20.4
see core.txt.example
'''

import requests
import copy
from dotenv import dotenv_values
import json
import os
from urllib3.exceptions import InsecureRequestWarning
import warnings
warnings.simplefilter('ignore', InsecureRequestWarning)

REPONAME = "qobserve"
USERNAME = dotenv_values(".env")["USERNAME"]
PASSWORD = username = dotenv_values(".env")["PASSWORD"]
CORES = "cores.txt"

proxies = {
    "http": "http://127.0.0.1:8080",
    "https": "http://127.0.0.1:8080"
}

proxies = {}


# api data
get_access_mode = {
    "method": "GET",
    "url": "/api/v0/cores/self/access_mode",
    "headers": {},
    "data": {},
    "file": []
}

log_in = { # returns {"token": "token"}
    "method": "POST",
    "url": "/api/v0/logon",
    "headers": {
        "Content-Type": "application/json"
    },
    "data": {
        "username": "",
        "password": ""
    },
    "file": []
}

delete_file = {
    "method": "DELETE",
    "url": "/api/v0/cores/self/media",
    "headers": {
        "Content-Type": "application/json"
    },
    "data": [],
    "file": []
}

create_folder = {
    "method": "POST",
    "url": "/api/v0/cores/self/media",
    "headers": {
        "Content-Type": "application/json"
    },
    "data": {"name": ""},
    "file": []
}

get_files = {
    "method": "GET",
    "headers": {},
    "url": "/api/v0/cores/self/media", # append folders at the end
    "data": {},
    "file": []
}

upload_file = {
    "method": "POST",
    "url": "/api/v0/cores/self/media", # append folder at the end
    "headers": {},
    "data": {},
    "file": []
}

# send request
def sendRequest(core, data={}):
    if data["file"]:
        d = data["data"]
    else:
        d = json.dumps(data["data"])
    r = requests.request(
        url=core + data["url"],
        method=data["method"],
        headers=data["headers"],
        data=d,
        files=data["file"],
        verify=False,
        proxies=proxies
    )
    return r


def getCores():
    cores = []
    with open(CORES, "r") as reader:
        for core in reader.readlines():
            cores.append(core.strip())
    return cores


def getAccessMode(core):
    r = sendRequest(core, get_access_mode)
    if r.status_code == 401:
        access_mode = True
    else:
        access_mode = False
    return access_mode


def logIn(core):
    data = log_in
    data["data"]["username"] = USERNAME
    data["data"]["password"] = PASSWORD
    r = sendRequest(core, data)
    token = json.loads(r.text)["token"]
    return token


def deleteRepo(core, token, parent_dir=REPONAME):
    data = copy.deepcopy(get_files)
    data["url"] = f"{data['url']}/{parent_dir}"
    if token:
        data["headers"]["Authorization"] = f"Bearer {token}"
    r = sendRequest(core, data)
    if r.status_code != 404:
        root = json.loads(r.text)
        for file in root:
            if file["type"] == "file":
                delete_data = []
                delete_data = copy.deepcopy(delete_file)
                if token:
                    delete_data["headers"]["Authorization"] = f"Bearer {token}"
                delete = f"{parent_dir}/{file['name']}"
                delete_data["data"] = [delete]
                print(f"deleting: {delete}")
                r = sendRequest(core, delete_data)
            elif file["type"] == "folder":
                deleteRepo(core, token, f"{parent_dir}/{file['name']}")
        delete_data = []
        delete_data = copy.deepcopy(delete_file)
        if token:
            delete_data["headers"]["Authorization"] = f"Bearer {token}"
        delete_data["data"] = [parent_dir]
        print(f"deleting: {parent_dir}")
        r = sendRequest(core, delete_data)
    else:
        print(f"{parent_dir} not found")


def getFile(path):
    with open(path, "rb") as reader:
        content = reader.read()
    return content


def uploadRepo(core, token):
    upload_dir = copy.deepcopy(create_folder)
    upload_dir["data"]["name"] = REPONAME
    if token:
        upload_dir["headers"]["Authorization"] = f"Bearer {token}"
    print(f"creating folder: {REPONAME}")
    sendRequest(core, upload_dir)
    for root, dirs, files in os.walk("../src", topdown=True):
        for name in dirs:
            rt = root.replace("../src", REPONAME)
            rt = rt.replace("\\", "/")
            upload_dir = copy.deepcopy(create_folder)
            upload_dir["url"] = f"{upload_dir['url']}/{rt}"
            upload_dir["data"]["name"] = name
            print(f"creating folder: {rt}/{name}")
            sendRequest(core, upload_dir)
        for name in files:
            rt = root.replace("../src", REPONAME)
            rt = rt.replace("\\", "/")
            upload_f = copy.deepcopy(upload_file)
            if token:
                upload_dir["headers"]["Authorization"] = f"Bearer {token}"
            upload_f["url"] = f"{upload_f['url']}/{rt}"
            upload_f["file"] = [
                (
                    "media",
                    (
                        name,
                        open(f"{root}/{name}", "rb"),
                        "application/octet-stream"
                    )
                )
            ]
            print(f"uploading: {rt}/{name}")
            sendRequest(core, upload_f)


def main():
    cores = getCores()
    for core in cores:
        print(core)
        am = getAccessMode(core)
        token = ""
        if am:
            token = logIn(core)
        deleteRepo(core, token)
        uploadRepo(core, token)

if __name__ == "__main__":
    main()
