#ifndef LLVM_TRANSFORMS_MY_FIRSTPASS_H
#define LLVM_TRANSFORMS_MY_FIRSTPASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {
    class MyFirstPass : public PassInfoMixin<MyFirstPass> {
    public:
        PreservedAnalyses run(Function& F, FunctionAnalysisManager &AM);
    };
}

#endif // LLVM_TRANSFORMS_MY_FIRSTPASS_H
