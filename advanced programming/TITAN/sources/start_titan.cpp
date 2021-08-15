#include "start_titan.h"
#include "ui_start_titan.h"
#include "mainwindow.h"
#include "secondary_thread.h"
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
#include "main_thread.h"
#include "chat.h"
#include "chatwithuser.h"
#include "chat3.h"
#include <QDialog>
 bool check;
start_titan::start_titan(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::start_titan)
{
    ui->setupUi(this);
    this->setStyleSheet("background-color: black");
    QPixmap pix("C:/Users/KPS/Downloads/titan.jpg");
    ui->label->setPixmap(pix);
    ui->logout->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->join_channel->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->create_channel->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->join_group->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->create_group->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->pushButton->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->pushButton_2->setStyleSheet("* { background-color: rgb(0,49,100) }");
    ui->pushButton_3->setStyleSheet("* { background-color: rgb(0,49,100) }");


    ui->label_2->setText("<font color='white'>user names</font>");
    ui->label_3->setText("<font color='white'>group names</font>");
    ui->label_5->setText("<font color='white'>channels names</font>");

    t_group = new main_thread ();
    connect(t_group,SIGNAL(main_signal()),this,SLOT(groupSlot()));
    t_group->start();

    t_channel = new main_thread ();
    connect(t_channel,SIGNAL(main_signal()),this,SLOT(channelSlot()));
    t_channel->start();

    t_user = new main_thread ();
    connect(t_user,SIGNAL(main_signal()),this,SLOT(userSlot()));
    t_user->start();

    QString name ;
    QFile inputFile("Data2.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       name = in.readLine();
       inputFile.close();
    }


    if(!QDir(name).exists()){
        QDir().mkdir(name);
    }

    if(!QDir(name+"/groups").exists()){
        QDir().mkdir(name+"/groups");
    }

     if(!QDir(name+"/channels").exists()){
        QDir().mkdir(name+"/channels");
    }

    if(!QDir(name+"/users").exists()){
        QDir().mkdir(name+"/users");
    }


}

start_titan::~start_titan()
{
    delete ui;
    t_channel->terminate();
    t_user->terminate();
    t_group->terminate();
    delete t_channel;
    delete t_user;
    delete t_group;
}


void start_titan::on_logout_clicked()
{
    QString username;
    QString password;

    QFile inputFile("Data2.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       username = in.readLine();
       inputFile.close();
    }

    QFile inputFile1("Data3.txt");
    if (inputFile1.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile1);
       password = in.readLine();
       inputFile1.close();
    }

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished);

    QString set_url= "http://api.softserver.org:1104/logout?username=";
    set_url += username;
    set_url += "&";
    set_url += "password=";
    set_url += password;

    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void start_titan::replyfinished(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

        if(js_code=="200")
        {

            ui->label_4->setText("<font color='green'>"+js1["message"].toString()+"</font>");

            QFile inputFile("Data.txt");
            inputFile.open(QIODevice::WriteOnly);

            QFile inputFile1("Data2.txt");
            inputFile1.open(QIODevice::WriteOnly);

            QFile inputFile2("Data3.txt");
            inputFile2.open(QIODevice::WriteOnly);

            this->close();
            MainWindow *newpage;
            newpage = new MainWindow();
            newpage->show();

        }
        else
            ui->label_4->setText("<font color='red'>"+js1["message"].toString()+"</font>");
}




void start_titan::on_create_group_clicked()
{
    QString groupname = ui->lineEdit_4->text();
    QString grouptitle = ui->lineEdit_3->text();

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished2);
     //                 http://api.softserver.org:1104/creategroup?token=7a3c48f7c7939b7269d01443a431825f&group_name=ap&group_title=Advance-programming
    QString set_url= "http://api.softserver.org:1104/creategroup?token=";

    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }

    set_url += token;
    set_url += "&";
    set_url += "group_name=";
    set_url += groupname;
    set_url += "&group_title=";
    set_url += grouptitle;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void start_titan::replyfinished2(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

        if(js_code=="200")
        {

            ui->label_4->setText("<font color='green'>"+js1["message"].toString()+"</font>");

        }
        else
            ui->label_4->setText("<font color='red'>"+js1["message"].toString()+"</font>");
}





void start_titan::on_create_channel_clicked()
{
    QString channelname = ui->lineEdit_5->text();
    QString channeltitle = ui->lineEdit_6->text();

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished3);
    QString set_url= "http://api.softserver.org:1104/createchannel?token=";
    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }

    set_url += token;
    set_url += "&";
    set_url += "channel_name=";
    set_url += channelname;
    set_url += "&channel_title=";
    set_url += channeltitle;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void start_titan::replyfinished3(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

        if(js_code=="200")
        {

            ui->label_4->setText("<font color='green'>"+js1["message"].toString()+"</font>");

        }
        else
            ui->label_4->setText("<font color='red'>"+js1["message"].toString()+"</font>");
}





void start_titan::on_join_group_clicked()
{
    QString groupname = ui->lineEdit_7->text();

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished4);
    QString set_url= "http://api.softserver.org:1104/joingroup?token=";
    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }

    set_url += token;
    set_url += "&";
    set_url += "group_name=";
    set_url += groupname;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void start_titan::replyfinished4(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

        if(js_code=="200")
        {
           ui->label_4->setText("<font color='green'>"+js1["message"].toString()+"</font>");
        }
        else
            ui->label_4->setText("<font color='red'>"+js1["message"].toString()+"</font>");
}


void start_titan::on_join_channel_clicked()
{
    QString channelname = ui->lineEdit_8->text();

    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished5);
    QString set_url= "http://api.softserver.org:1104/joinchannel?token=";
    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }

    set_url += token;
    set_url += "&";
    set_url += "channel_name=";
    set_url += channelname;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}

void start_titan::replyfinished5(QNetworkReply * reply){
        QJsonDocument js;
        js=QJsonDocument::fromJson(reply->readAll());
        QJsonObject js1=js.object();
        QString js_code = js1["code"].toString();

        if(js_code=="200")
        {
            ui->label_4->setText("<font color='green'>"+js1["message"].toString()+"</font>");
        }
        else
            ui->label_4->setText("<font color='red'>"+js1["message"].toString()+"</font>");
}

void start_titan::groupSlot(){
    if(check){
    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished6);

    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
       QTextStream in(&inputFile);
       token = in.readLine();
       inputFile.close();
    }
    QString set_url= "http://api.softserver.org:1104/getgrouplist?token=";
    set_url += token;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
    }


    else{
        ui->group_names->clear();
        QFile file4( "group_name_data.txt" );
        if(file4.open(QIODevice::ReadOnly));
        {
            QTextStream in(&file4);
            QString name;
            name=in.readLine();
            while(name!=0){
                ui->group_names->insertHtml("<font color='white'>"+name+"<\font>");
                ui->group_names->insertHtml("<br>");
                name=in.readLine();
            }
        }
    }

}
void start_titan::replyfinished6(QNetworkReply * reply){
    QJsonDocument js;
    js=QJsonDocument::fromJson(reply->readAll());
    QJsonObject js1=js.object();
    QString js_code = js1["code"].toString();
    QString js_message = js1["message"].toString();

    QString adad;
    adad[0]=js_message[12];
    if(js_message[14]=='-')
    {
        adad[1]=js_message[13];
    }
    ui->group_names->clear();
    int counter = adad.toInt();
    if(js_code=="200")
    {
        QString name ;
        QFile inputFile("Data2.txt");
        if (inputFile.open(QIODevice::ReadOnly))
        {
           QTextStream in(&inputFile);
           name = in.readLine();
           inputFile.close();
        }


        QString filename4="group_name_data.txt";
        QFile file4( filename4 );
        if(file4.open(QIODevice::WriteOnly));
        {

        }

         for(int i=0;i<counter;i++)
         {
              QJsonObject jsb= js1["block "+ QString::number(i)].toObject();
              ui->group_names->insertHtml("<font color='white'>"+jsb["group_name"].toString()+"<\font>");
              ui->group_names->insertHtml("<br>");

              QString filename4="group_name_data.txt";
              QFile file4( filename4 );
              if(file4.open(QIODevice::Append));
              {
                  QTextStream stream(&file4);
                  stream << jsb["group_name"].toString() << endl;
              }

              QString filename=name+"/groups/"+jsb["group_name"].toString()+".txt";
              QFile file( filename );
              if ( file.open(QIODevice::ReadWrite) )
              {

              }

         }

    }
}


 void start_titan::channelSlot(){
     if(check){
    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished7);

    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&inputFile);
        token = in.readLine();
        inputFile.close();
    }
    QString set_url= "http://api.softserver.org:1104/getchannellist?token=";
    set_url += token;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
     }


     else{
         ui->channel_names->clear();
         QFile file4( "channel_name_data.txt" );
         if(file4.open(QIODevice::ReadOnly));
         {
             QTextStream in(&file4);
             QString name;
             name=in.readLine();
             while(name!=0){
                 ui->channel_names->insertHtml("<font color='white'>"+name+"<\font>");
                 ui->channel_names->insertHtml("<br>");
                 name=in.readLine();
             }
         }
     }

 }


void start_titan::replyfinished7(QNetworkReply * reply){
     QJsonDocument js;
     js=QJsonDocument::fromJson(reply->readAll());
     QJsonObject js1=js.object();
     QString js_code = js1["code"].toString();
     QString js_message = js1["message"].toString();

     QString adad;
     adad[0]=js_message[12];
     if(js_message[14]=='-')
     {
         adad[1]=js_message[13];
     }
     ui->channel_names->clear();
     int counter = adad.toInt();
     if(js_code=="200")
     {
         QString name ;
         QFile inputFile("Data2.txt");
         if (inputFile.open(QIODevice::ReadOnly))
         {
            QTextStream in(&inputFile);
            name = in.readLine();
            inputFile.close();
         }


         QString filename4="channel_name_data.txt";
         QFile file4( filename4 );
         if(file4.open(QIODevice::WriteOnly));
         {
                file4.close();
         }


         for(int i=0;i<counter;i++)
          {
              QJsonObject jsb= js1["block "+ QString::number(i)].toObject();
              ui->channel_names->insertHtml("<font color='white'>"+jsb["channel_name"].toString()+"<\font>");
              ui->channel_names->insertHtml("<br>");



              if(file4.open(QIODevice::Append));
                 {
                  QTextStream stream(&file4);
                  stream << jsb["channel_name"].toString() << endl;
                  file4.close();
              }


               QString filename=name+"/channels/"+jsb["channel_name"].toString()+".txt";
               QFile file( filename );
               if ( file.open(QIODevice::ReadWrite) )
               {
                    file.close();
               }
          }

     }
}

void start_titan::userSlot(){
    if(check){
    QNetworkAccessManager* name = new QNetworkAccessManager(this);
    connect(name, &QNetworkAccessManager::finished,this,&start_titan::replyfinished8);

    QString token ;
    QFile inputFile("Data.txt");
    if (inputFile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&inputFile);
        token = in.readLine();
        inputFile.close();
    }
    QString set_url= "http://api.softserver.org:1104/getuserlist?token=";
    set_url += token;
    QUrl url(set_url);
    QNetworkReply* reply = name->get(QNetworkRequest(url));
}


else{
    ui->user_names->clear();
    QFile file4( "user_name_data.txt" );
    if(file4.open(QIODevice::ReadOnly));
    {
        QTextStream in(&file4);
        QString name;
        name=in.readLine();
        while(name!=0){
            ui->user_names->insertHtml("<font color='white'>"+name+"<\font>");
            ui->user_names->insertHtml("<br>");
            name=in.readLine();
        }
    }
}

}

void start_titan::replyfinished8(QNetworkReply * reply){
     QJsonDocument js;
     js=QJsonDocument::fromJson(reply->readAll());
     QJsonObject js1=js.object();
     QString js_code = js1["code"].toString();
     QString js_message = js1["message"].toString();

     QString adad;
     adad[0]=js_message[20];
     if(js_message[22]=='-')
     {
         adad[1]=js_message[21];
     }
     ui->user_names->clear();
     int counter = adad.toInt();

     if(js_code=="200")
     {
         QString name ;
         QFile inputFile("Data2.txt");
         if (inputFile.open(QIODevice::ReadOnly))
         {
            QTextStream in(&inputFile);
            name = in.readLine();
            inputFile.close();
         }

         QString filename5="user_name_data.txt";
         QFile file5( filename5 );
         if(file5.open(QIODevice::WriteOnly));
         {
                file5.close();
         }



          for(int i=0;i<counter;i++)
          {
              QJsonObject jsb= js1["block "+ QString::number(i)].toObject();
              ui->user_names->insertHtml("<font color='white'>"+jsb["src"].toString()+"<\font>");
              ui->user_names->insertHtml("<br>");

              if(file5.open(QIODevice::Append));
                 {
                  QTextStream stream(&file5);
                  stream << jsb["src"].toString() << endl;
                  file5.close();
              }


              QString filename=name+"/users/"+jsb["src"].toString()+".txt";
              QFile file( filename );
              if ( file.open(QIODevice::ReadWrite) )
              {

              }
          }
     }
}



void start_titan::on_pushButton_clicked()
{
    this->close();
    chatWithUser * newpage=new chatWithUser ;
    newpage->setName(ui->input_usernames->text());
    newpage->show();
}

void start_titan::on_pushButton_2_clicked()
{
    chat* newpage=new chat;
    QFile inputFile("sended.txt");

    QFile myfile("group_name_data.txt");

    if (myfile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&myfile);
        QString name=in.readLine();
        while(name!=0)
        {
               if(name == ui->input_groupnames->text() )
               {
                    if (inputFile.open(QIODevice::WriteOnly))
                    {
                         QTextStream stream(&inputFile);
                         stream << ui->input_groupnames->text();
                    }
                    this->close();
                    newpage->setName(ui->input_groupnames->text());
                    newpage->show();
                    break;
                }
                else
                {
                    ui->label_4->clear();
                    ui->label_4->setText("<font color='red'>there is no such group</font>");
                }
                name=in.readLine();
      }
   }

}

void start_titan::on_pushButton_3_clicked()
{

    chat3* newpage=new chat3;
    QFile inputFile("sended.txt");

    QFile myfile("channel_name_data.txt");

    if (myfile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&myfile);
        QString name=in.readLine();
        while(name!=0)
        {
               if(name == ui->input_channelnames->text() )
               {
                    if (inputFile.open(QIODevice::WriteOnly))
                    {
                         QTextStream stream(&inputFile);
                         stream << ui->input_channelnames->text();
                    }
                    this->close();
                    newpage->setName(ui->input_channelnames->text());
                    newpage->show();
                    break;
                }
                else
                {
                    ui->label_4->clear();
                    ui->label_4->setText("<font color='red'>there is no such channel</font>");
                }
                name=in.readLine();
      }
   }
}

void start_titan::chapOffline()
{

}


// check for connection
bool chat::cc(){
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
