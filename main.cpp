#include <QtWidgets>

#include <QtPlugin>

#ifdef QT_STATIC
QT_BEGIN_NAMESPACE
Q_IMPORT_PLUGIN (QCocoaIntegrationPlugin);
Q_IMPORT_PLUGIN (QMacStylePlugin);
QT_END_NAMESPACE
#endif

int main(int argc, char *argv[])
{
  QApplication app(argc, argv);
  QLabel l("Hello, World 1 " ) ;
  l.show();
  return app.exec();
}