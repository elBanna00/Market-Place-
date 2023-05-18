# Distributed Project
## Run Frontend
1- Open Vscode

2- Download server extension live server

3- Tap on settings (Gear Icon)

4- Select Extension Settings

5- Click Edit in settings.json

6- set "liveServer.settings.port" to 3000

7- Web Directory in vscode

8- Click Go live from bottom right

## Run Backend
1- You have to install python

2- Open VScode

3- Open the `backend` Directory

4- Open Terminal of VScode

5- Run
```
pip install django
```
6- Run
```
pip install djangorestframework
```

7- Run
```
pip install mysqlclient
```

8- Run
```
pip install django-cors-headers
```

9- open myproject/settings.py

10- insert `http://"Your_IP":3000` in CORS_ALLOWED_ORIGINS1

11- python manage.py runserver

## Initialize Database
1- Run MySql workbench

2- Run Connection at port 3306

3- Copy `Sql Creator.txt` in script

4- Copy `Insert Dumpy data.txt` in script

5- Go VScode

6- open myproject/settings.py

7- DATABASES edit `HOST`, `USER` and `PASSWORD`
