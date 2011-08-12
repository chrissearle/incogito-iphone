#ifdef APPDEBUG
#define AppLog(format...) AppDebugLog(__FILE__, __LINE__, format)
#else
#define AppLog(format...)
#endif