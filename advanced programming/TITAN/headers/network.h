#ifndef NETWORK_H
#define NETWORK_H
#include <QtNetwork>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class network
{
    Q_OBJECT
public:
    explicit network(QObject *parent = 0);
    bool check_connection();

signals:

public slots:

};

#endif // NETWORK_H
