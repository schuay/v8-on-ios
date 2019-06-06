#ifndef Console_h
#define Console_h

#include "v8include.h"

namespace tns {

class Console {
public:
    static void Init(v8::Isolate* isolate);
private:
    static void LogCallback(const v8::FunctionCallbackInfo<v8::Value>& args);
};

}

#endif /* Console_h */
