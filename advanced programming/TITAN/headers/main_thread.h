#ifndef MAIN_THREAD_H
#define MAIN_THREAD_H

#include <QThread>

class main_thread : public QThread
{
    Q_OBJECT
public:
    explicit main_thread(QObject *parent = 0);
    void run();
signals:
    void main_signal();
public slots:

};

#endif // MAIN_THREAD_H
