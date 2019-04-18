#include "Helpers.h"

using namespace v8;

Local<String> tns::ToV8String(Isolate* isolate, std::string value) {
    return String::NewFromUtf8(isolate, value.c_str(), NewStringType::kNormal).ToLocalChecked();
}

std::string tns::ToString(Isolate* isolate, const Local<Value>& value) {
    if (value.IsEmpty()) {
        return std::string();
    }

    String::Utf8Value result(isolate, value);
    return std::string(*result);
}
