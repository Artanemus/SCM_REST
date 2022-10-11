# SCM_REST

REST server for the SwimClubMeet database. API for mobile devices and web.

![Hero REST ICON](ASSETS/SCM_REST_150x150.png)

---

SCM_REST is a 64bit DLL written in pascal. It's part of an eco system of applications that makes up the SwimClubMeet project. SCM lets amateur swimming clubs manage members and run their club night's. (Wit: a meet manager.)

![The eco system of SCM](ASSETS/SCM_GroupOfIcons.png)

To learn more about SCM view the [github pages](https://artanemus.github.io/index.html).

If you are interested in following a developer's blog and track my progress then you can find me at [ko-fi](https://ko-fi.com/artanemus).

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/V7V7EU686)

---

## USING SCM_REST

There are three folders.

---

Folder 1- STANDALONE. A standalone exe version of the REST. Used for debugging on localHost\SQLEXPRESS.

![ScreenShot StandAlone debug app.](ASSETS/Screenshot%202022-10-10%20145310.JPG)

Yes, not that pretty. But it's only used for debugging.

---

Folder 2 -IISAPI - a 64bit dll for the website's CGI folder. A release version of SCM_REST.

![ScreenShot Demo example tab1.](ASSETS/Screenshot%202022-10-10%20150732.JPG)

The Embarcadero RAD project with the directory selected that builds the dll.

---

Folder 3- CLIENT. A RAD FireMonkey application that test's the API point of the REST service.

![ScreenShot Demo example tab1.](ASSETS/Screenshot%202022-10-10%20145604.JPG)

Again, not pretty - but it demonstrates that it works!

---

## IMPORTANT NOTE

This REST service will look for a configuration file.

>SCM_RESTConfig.ini

    [MSSQL_SwimClubMeet] 
    Database=SwimClubMeet
    OSAuthent=Yes
    Server=localhost\SQLEXPRESS
    DriverID=MSSQL
    MetaDefSchema=dbo
    ExtendedMetadata=False
    MetaDefCatalog=
    ApplicationName=SwimClubMeet
    Workstation=localhost
    MARS=yes
    User_Name=
    Password=

It'll look-in...

    SYSTEMDRIVE:\Users\USERNAME\AppData\Roaming\Artanemus\SCM\

If that fails it'll looks into the root folder (this should be you CGI bin - haven't checked this!)

If that fails - it'll attempts to make a connection to localHost\SQLEXPRESS - using os authentication. (Which is convenient for debugging.)

But you have all the code ... do what you will!

---

## OTHER BITS - ALSO GOOD READING

To use a REST service, you need to enable Window's Internet Information Services. Then place SCM_REST.dll into the (website's) CGI folder.

On the CLIENT side you can request JSON data from the REST service by ...

>To see all the sessions...

        http://localHost/SQLEXPRESS:8080/sessions?sessionid=0

>To see all the events for a specific session...

        http://localHost/SQLEXPRESS:8080 /events?sessionid=63&eventid=0

>To see all the heats for a specific event... (and race-times)

        http://localHost/SQLEXPRESS:8080 /heats?eventid=162&heatid=0

The demo application has been written in a cross-platform compiler. This means the demo application could easily be compiled for Android, iOS, etc.

If you know Delphi and have the Embarcadero community edition of the compiler (which is free) - you can use my demo as a template to a build a fantastic mobile version for your club.

It's possible to run SCM_REST on IIS wwwroot. (No website needed). Your laptop would be running SQLEXPRESS and SCM_REST. Your members can then connect to the club's wi-fi on their phones to see the night's schedule and race times.

(The mobile app would use an IP address and port 8080 to find the REST service.)

Cheers

Have a great club-night 😉
