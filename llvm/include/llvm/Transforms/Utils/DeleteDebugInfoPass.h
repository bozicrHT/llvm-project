#ifndef DELETE_DEBUG_INFO_PASS_H
#define DELETE_DEBUG_INFO_PASS_H

#include <vector>

#include "llvm/IR/PassManager.h"
#include "llvm/IR/DebugProgramInstruction.h"

using namespace llvm;

namespace llvm {

    class DeleteDebugInfoPass : public PassInfoMixin<DeleteDebugInfoPass> {
        void GetDebugRecords(Function& F);
        void RemoveDebugRecords();
        std::vector<DbgVariableRecord*> RecordsToRemove;
        bool Changed;

    public:
        PreservedAnalyses run(Function& F, FunctionAnalysisManager& AM);

    };

}

#endif // DELETE_DEBUG_INFO_PASS_H
