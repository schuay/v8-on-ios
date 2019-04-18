#ifndef Helpers_h
#define Helpers_h

#include <string>

#include "v8include.h"

namespace tns {

v8::Local<v8::String> ToV8String(v8::Isolate* isolate, std::string value);
std::string ToString(v8::Isolate* isolate, const v8::Local<v8::Value>& value);

}

#endif /* Helpers_h */
