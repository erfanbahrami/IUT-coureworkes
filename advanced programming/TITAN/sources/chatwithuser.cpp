#include "chatwithuser.h"
#include "ui_chatwithuser.h"
#include "start_titan.h"
#include <QDialog>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QWidget>
#include <iostream>
#include <QFile>
#include <QString>
#include "secondary_thread.h"
extern bool check;
chatWithUser::chatWithUser(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::chatWithUser)
{
    ui->setupUi(this);

    this->setStyleSheet("background-color: black");
    ui->pushButton->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->back->setStyleSheet("* { background-color: rgb(0,49,100) }");

    t_user = new secondary_thread;
    connect(t_user,SIGNAL(secondary_signal()),this,SLOT(userSlut()));
    t_user->start();
}

chatWithUser::~chatWithUser()
{
    delete ui;
    t_user->terminate();
    delete t_user;
}

void chatWithUser::setName(QString x)
{
    sended_username = x;
}

void chatWithUser::userSlut()
{
QNetworkReply* reply;
if(check)
{
    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&chatWithUser::replyfinished10);

    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }
    QString set_url= "http://api.softserver.org:1104/getuserchats?token=";
    set_url += token;
    set_url +="&dst=";
    set_url += sended_username ;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}
else
{
    ui->textBrowser->clear();
    QString name ;
    QFile inputFile2("Data2.txt");
    if (inputFile2.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile2);
       name = in.readLine();
       inputFile2.close();
    }
    QFile inputFile(name+"/users/"+ sended_username+".txt");
    if(inputFile.open(QIODevice::ReadOnly))
    {
        QString body,src,dst,date;
        body = inputFile.readLine();
        while(body!=0)
        {
            src = inputFile.readLine();
            src.remove('\n');
            dst = inputFile.readLine();
            date = inputFile.readLine();

            //ui->textBrowser->insertHtml("<strong>"+src+"</strong>");

            ui->textBrowser->insertHtml("<font size=3 color='white'>"+src+"</font>");
            ui->textBrowser->insertHtml("<font color='white'> : </font>");
            ui->textBrowser->insertHtml("<font size= 4 color = 'white'>"+body+"</font>");
            ui->textBrowser->insertHtml("<br>");
            body = inputFile.readLine();
           // ui->plainTextEdit->setLayoutDirection(Qt::RightToLeft);
            t_user->quit();
        }

    }

    ui->textBrowser->moveCursor(QTextCursor::End);
}
}

void chatWithUser::replyfinished10(QNetworkReply * reply)
{
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();
        QString js_message = js1["message"].toString();

        QString adad;
        adad[0]=js_message[11];
        if(js_message[13]=='-')
        {
            adad[1]=js_message[12];
        }
        int counter = adad.toInt();

        if(js_code=="200")
        {
            QString name ;
            QFile inputFile2("Data2.txt");
            if (inputFile2.open(QIODevice::ReadOnly))
            {
               QTextStream in(&inputFile2);
               name = in.readLine();
               inputFile2.close();
            }

            QFile inputFile(name+"/groups/"+ sended_username+".txt");
            inputFile.open(QIODevice::WriteOnly);
            inputFile.close();


            for(int i=0;i<counter;i++)
            {
                  QJsonObject jsb= js1["block "+ QString::number(i)].toObject();
                  if (inputFile.open(QIODevice::Append))
                  {
                      QTextStream stream(&inputFile);
                      stream << jsb["body"].toString() << endl << jsb["src"].toString()<< endl
                      <<jsb["dst"].toString()<<endl<<jsb["date"].toString()<<endl;
                      inputFile.close();
                  }
           }
        }
    ui->textBrowser->clear();
    QString name ;
    QFile inputFile2("Data2.txt");
    if (inputFile2.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile2);
       name = in.readLine();
       inputFile2.close();
    }
    QFile inputFile(name+"/groups/"+ sended_username+".txt");
    if(inputFile.open(QIODevice::ReadOnly))
    {
        QString body,src,dst,date;
        body = inputFile.readLine();
        while(body!=0)
        {
            src = inputFile.readLine();
            src.remove('\n');
            dst = inputFile.readLine();
            date = inputFile.readLine();

            ui->textBrowser->insertHtml("<font size=3 color='white'>"+src+"</font>");
            ui->textBrowser->insertHtml("<font color='white'> : </font>");
            ui->textBrowser->insertHtml("<font size= 4 color = 'white'>"+body+"</font>");
            ui->textBrowser->insertHtml("<br>");
            body = inputFile.readLine();

        }

    }
    ui->textBrowser->moveCursor(QTextCursor::End);
}



void chatWithUser::on_pushButton_clicked()
{
    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&chatWithUser::replyfinished12);
    QString set_url= "http://api.softserver.org:1104/sendmessageuser?token=";
    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }
    set_url += token;
    set_url += "&dst=";
    set_url += sended_username;
    set_url += "&body=";
    set_url += ui->lineEdit->text();

    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void chatWithUser::replyfinished12(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

            if(js_code=="200")
            {
                ui->textBrowser_2->clear();
                ui->textBrowser_2->insertHtml("<font color='green'>"+js1["message"].toString()+"</font>");        
            }
            else
            {
                ui->textBrowser_2->clear();
                ui->textBrowser_2->insertHtml("<font color='red'>"+js1["message"].toString()+"</font>");
            }
}


// check for connection
bool chatWithUser::cc(){
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


void chatWithUser::on_back_clicked()
{
    this->close();
    start_titan *newpage=new start_titan;
    newpage->show();
}
