#ifndef Runtime_h
#define Runtime_h

#include "v8include.h"
#include "include/libplatform/libplatform.h"

namespace tns {

class Runtime {
public:
    void Init(const std::string& baseDir);
    void RunScript(std::string file);
    
private:
    v8::Isolate* InitInternal(const std::string& baseDir);
    static std::string ReadText(const std::string& file);
    
    v8::Platform* platform_;
    v8::Isolate* isolate_;
    std::string baseDir_;
};

}

#endif /* Runtime_h */
