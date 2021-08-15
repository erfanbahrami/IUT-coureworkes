#ifndef SECONDARY_THREAD_H
#define SECONDARY_THREAD_H

#include <QThread>

class secondary_thread : public QThread
{
    Q_OBJECT
public:
    explicit secondary_thread(QObject *parent = 0);
    void run();
signals:
    void secondary_signal();

public slots:

};

#endif // SECONDARY_THREAD_H
