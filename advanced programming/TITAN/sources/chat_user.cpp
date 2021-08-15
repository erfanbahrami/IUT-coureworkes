#include "chat_user.h"
#include "ui_chat_user.h"
#include "secondary_thread.h"
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

chat_user::chat_user(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::chat_user)
{
    ui->setupUi(this);

    t_user = new secondary_thread;
    connect(t_user,SIGNAL(secondary_signal()),this,SLOT(groupSlut()));
    t_user->start();
}

chat_user::~chat_user()
{
    delete ui;
}

//void chat_user::setName(QString x)
//{
//    sended_username = x;
//}

//void chat_user::userSlut()
//{
//        QNetworkAccessManager* name = new QNetworkAccessManager(this);
//        connect(name, &QNetworkAccessManager::finished,this,&chat_user::replyfinished10);

//        QString token ;
//        QFile inputFile("Data.txt");
//        if (inputFile.open(QIODevice::ReadOnly))
//        {
//           QTextStream in(&inputFile);
//           token = in.readLine();
//           inputFile.close();
//        }
//        QString set_url= "http://api.softserver.org:1104/getuserchats?token=";
//        set_url += token;
//        set_url +="&dst=";
//        set_url += sended_username ;
//        QUrl url(set_url);
//        QNetworkReply* reply = name->get(QNetworkRequest(url));
//}

//void chat_user::replyfinished10(QNetworkReply * reply)
//{
//    if(cc())
//    {
//        QJsonDocument js;
//        js=QJsonDocument::fromJson(reply->readAll());
//        QJsonObject js1=js.object();
//        QString js_code = js1["code"].toString();
//        QString js_message = js1["message"].toString();

//        QString adad;
//        adad[0]=js_message[11];
//        if(js_message[13]=='-')
//        {
//            adad[1]=js_message[12];
//        }
//        int counter = adad.toInt();

//        if(js_code=="200")
//        {
//            QString name ;
//            QFile inputFile2("Data2.txt");
//            if (inputFile2.open(QIODevice::ReadOnly))
//            {
//               QTextStream in(&inputFile2);
//               name = in.readLine();
//               inputFile2.close();
//            }

//            QFile inputFile(name+"/users/"+ sended_username+".txt");
//            inputFile.open(QIODevice::WriteOnly);
//            inputFile.close();


//            for(int i=0;i<counter;i++)
//            {
//                  QJsonObject jsb= js1["block "+ QString::number(i)].toObject();
//                  if (inputFile.open(QIODevice::Append))
//                  {
//                      QTextStream stream(&inputFile);
//                      stream << jsb["body"].toString() << endl << jsb["src"].toString()<< endl
//                      <<jsb["dst"].toString()<<endl<<jsb["date"].toString()<<endl;
//                      inputFile.close();
//                  }
//            }
//         }
//   }//if
//    ui->plainTextEdit->clear();
//    QString name ;
//    QFile inputFile2("Data2.txt");
//    if (inputFile2.open(QIODevice::ReadOnly))
//    {
//       QTextStream in(&inputFile2);
//       name = in.readLine();
//       inputFile2.close();
//    }
//    QFile inputFile(name+"/users/"+ sended_username+".txt");
//    if(inputFile.open(QIODevice::ReadOnly))
//    {
//        QString body,src,dst,date;
//        body = inputFile.readLine();
//        while(body!=0)
//        {
//            src = inputFile.readLine();
//            src.remove('\n');
//            dst = inputFile.readLine();
//            date = inputFile.readLine();
//            ui->plainTextEdit->insertPlainText(src);
//            ui->plainTextEdit->insertPlainText(":"+body+"\n");
//            body = inputFile.readLine();
//            //ui->plainTextEdit->setLayoutDirection(Qt::RightToLeft);
//        }
//    }
//    ui->plainTextEdit->moveCursor(QTextCursor::End);
//}



//// check for connection
//bool chat_user::cc(){
//    QNetworkAccessManager nam;
//    QNetworkRequest req(QUrl("http://www.google.com"));
//    QNetworkReply *reply = nam.get(req);
//    QEventLoop loop;
//    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
//    loop.exec();
//    if(reply->bytesAvailable())
//         return true;
//    else
//         return false;
//}

