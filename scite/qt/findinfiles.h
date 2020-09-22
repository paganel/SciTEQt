/*
 * Code taken from visiscript project and addapted for sciteqt.
 *
 * (C) 2015-2020 by Michael Neuroth
 *
 */

#ifndef FINDINFILES_H
#define FINDINFILES_H

#include <QObject>

class FindInFilesInThread;

class FindInFilesAsync : public QObject
{
    Q_OBJECT

public:
    FindInFilesAsync();
    virtual ~FindInFilesAsync();

    void StartSearch( const QString & sSearchDir, const QString & sSearchFiles, const QString & sFindTextIn, bool bCaseSensitive, bool bOnlyWholeWords, bool bRegularExpr );

public slots:
    void sltFindThreadFinished();
    void sltFindThreadTerminated();

signals:
    void addToOutput(const QString & text);

protected:
    virtual void customEvent(QEvent * pEvent);

private:
    FindInFilesInThread *   m_pFindThread;

    bool                    m_bStopFlag;
    int                     m_iCount;
    int                     m_iFoundFileCount;
    int                     m_iTotalFileCount;
};

#endif // FINDINFILES_H
