#ifndef DEBUG_PASS_H
#define DEBUG_PASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {

    class DebugPass : public PassInfoMixin<DebugPass> {
    public:
        PreservedAnalyses run(Function& F, FunctionAnalysisManager& AM);
        void CountRecords(Function& F);

        std::unordered_map<std::string, int> RecordsMap;
    };
}

#endif // DEBUG_PASS_H
