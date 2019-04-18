#include <string>
#include <chrono>

#include "Runtime.h"
#include "Helpers.h"
#include "Console.h"

using namespace v8;
using namespace std;

namespace tns {

void Runtime::Init(const string& baseDir) {
    isolate_ = InitInternal(baseDir);
}

Isolate* Runtime::InitInternal(const string& baseDir) {
    baseDir_ = baseDir;

    platform_ = platform::NewDefaultPlatform().release();
    V8::InitializePlatform(platform_);
    V8::Initialize();

    std::string flags = "--expose_gc --jitless --allow-natives-syntax";
    V8::SetFlagsFromString(flags.c_str(), (int)flags.size());

    Isolate::CreateParams create_params;
    create_params.array_buffer_allocator = ArrayBuffer::Allocator::NewDefaultAllocator();
    Isolate* isolate = Isolate::New(create_params);

    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    Local<FunctionTemplate> globalTemplateFunction = FunctionTemplate::New(isolate);
    Local<ObjectTemplate> globalTemplate = ObjectTemplate::New(isolate, globalTemplateFunction);
    Local<Context> context = Context::New(isolate, nullptr, globalTemplate);
    context->Enter();

    Console::Init(isolate);

    return isolate;
}

void Runtime::RunScript(string file) {
    Isolate* isolate = isolate_;
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    Local<Context> context = isolate->GetCurrentContext();
    string source = Runtime::ReadText(baseDir_ + "/" + file);
    Local<v8::String> script_source = v8::String::NewFromUtf8(isolate, source.c_str(), NewStringType::kNormal).ToLocalChecked();
    Local<Script> script;
    TryCatch tc(isolate);
    if (!Script::Compile(context, script_source).ToLocal(&script) && tc.HasCaught()) {
        printf("%s\n", tns::ToString(isolate_, tc.Exception()).c_str());
        assert(false);
    }

    Local<Value> result;
    if (!script->Run(context).ToLocal(&result)) {
        if (tc.HasCaught()) {
            printf("%s\n", tns::ToString(isolate_, tc.Exception()).c_str());
        }
        assert(false);
    }
}

std::string Runtime::ReadText(const std::string& file) {
    std::ifstream ifs(file);
    if (ifs.fail()) {
        assert(false);
    }
    std::string content((std::istreambuf_iterator<char>(ifs)), (std::istreambuf_iterator<char>()));
    return content;
}

}
