#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QWidget>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>
#include <QMessageBox>
#include <QString>
#include <iostream>
#include "start_titan.h"
#include <windows.h>
#include <QFile>
extern bool check;

MainWindow::MainWindow(QWidget *parent):
    QMainWindow(parent)
,    ui(new Ui::MainWindow)
{

    if(check)
    {
    ui->setupUi(this);
    this->setStyleSheet("background-color: black"";");
    QPixmap pix("C:/Users/KPS/Downloads/titan.jpg");
    ui->label->setPixmap(pix);
    ui->label_2->setText("<font color='white'>If you don't have an account , Sign_up</font>");
    ui->label_3->setText("<font color='white'>If already have an account , Log_in</font>");

    ui->login_button->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->signup_button->setStyleSheet("* { background-color: rgb(0,49,100) }");


        QFile inputFile("Data2.txt");
        QFile inputFile2("Data3.txt");

        inputFile.open(QIODevice::ReadOnly);
        inputFile2.open(QIODevice::ReadOnly);

        if(inputFile.size()!=0 && inputFile2.size()!=0 )
        {

            QTextStream in(&inputFile);
            username = in.readLine();
            inputFile.close();

            QTextStream in2(&inputFile2);
            password = in2.readLine();
            inputFile2.close();

            on_login_button_clicked();

        }

   }
   else
   {
        this->close();
        start_titan newpage;
        //newpage->setName(ui->input_channelnames->text());
        newpage.setModal(true);
        newpage.exec();
   }

}

MainWindow::~MainWindow()
{

    delete ui;
}

// check for connection
bool MainWindow::cc(){
    QNetworkAccessManager nam;
    QNetworkRequest req(QUrl("http://www.google.com"));
    QNetworkReply *reply = nam.get(req);
    QEventLoop loop;
    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    if(reply->bytesAvailable())
         return true;
    else
         return false;
}


void MainWindow::on_signup_button_clicked()
{
    QString username = ui->Username-> text();
    QString password = ui->Password-> text();
    QString firstname= ui->Firstname->text();
    QString lastname = ui->Lastname-> text();

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&MainWindow::replyfinished);


    QString set_url= "http://api.softserver.org:1104/signup?username=";
    set_url += username;
    set_url += "&";
    set_url += "password=";
    set_url += password;

    if(firstname != NULL && lastname != NULL)
    {
        set_url += "&firstname=";
        set_url += firstname;
        set_url += "&lastname=";
        set_url += lastname;
    }
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));

}


void MainWindow::on_login_button_clicked()
{

    QFile inputFile("Data2.txt");
    QFile inputFile2("Data3.txt");

    inputFile.open(QIODevice::ReadOnly);
    inputFile2.open(QIODevice::ReadOnly);
    if(inputFile.size()==0 && inputFile2.size()==0 )
    {
        username = ui->Username2->text();
        password = ui->password2->text();
   }


    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&MainWindow::replyfinished2);

    QString set_url= "http://api.softserver.org:1104/login?username=";
    QString set_url2= "http://api.softserver.org:1104/logout?username=";
    QString set_url3 = username;
    set_url3 += "&password=";
    set_url3 += password;
    QUrl url(set_url+set_url3);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}


void MainWindow::replyfinished(QNetworkReply * reply){
    QJsonDocument js;
    js=QJsonDocument::fromJson(reply->readAll());
    QJsonObject js1=js.object();
    QString js_code = js1["code"].toString();

    if(js_code=="200")
    {

        ui->label_4->setText("<font color='green'>"+ js1["message"].toString()+"</font>");

    }
    else{
       ui->label_4->setText("<font color='red'>"+ js1["message"].toString()+"</font>");

       QFile inputFile("Data.txt");
       inputFile.open(QIODevice::WriteOnly);

       QFile inputFile1("Data2.txt");
       inputFile1.open(QIODevice::WriteOnly);

       QFile inputFile2("Data3.txt");
       inputFile2.open(QIODevice::WriteOnly);
    }
}


void MainWindow::replyfinished2(QNetworkReply * reply){
    QJsonDocument js;
    js=QJsonDocument::fromJson(reply->readAll());
    QJsonObject js1=js.object();
    QString js_code = js1["code"].toString();
    QString message = js1["message"].toString();
    QString token = js1["token"].toString();

    QString filename="Data.txt";
    QFile file( filename );
    if ( file.open(QIODevice::ReadWrite) )
    {
        QTextStream stream( &file );
        stream << token ;
        file.close();
    }

    QString filename2="Data2.txt";
    QFile file2( filename2 );
    if ( file2.open(QIODevice::WriteOnly) )
    {
        QTextStream stream( &file2 );
        stream << username ;
        file2.close();
    }

    QString filename3="Data3.txt";
    QFile file3( filename3 );
    if ( file3.open(QIODevice::WriteOnly) )
    {
        QTextStream stream( &file3 );
        stream << password ;
        file3.close();
    }

    if(js_code=="200")
    {



        ui->label_5->setText("<font color='green'>"+ js1["message"].toString()+"</font>");
        this->close();
        start_titan newpage;
        newpage.setModal(true);
        newpage.exec();
    }
    else
       ui->label_5->setText("<font color='red'>"+ js1["message"].toString()+"</font>");

}

