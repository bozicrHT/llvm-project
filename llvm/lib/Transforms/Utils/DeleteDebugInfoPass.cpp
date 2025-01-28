#include "llvm/Transforms/Utils/DeleteDebugInfoPass.h"
#include "llvm/IR/Function.h"

using namespace llvm;

PreservedAnalyses DeleteDebugInfoPass::run(Function& F, FunctionAnalysisManager& AM)
{
    GetDebugRecords(F);

    RemoveDebugRecords();

    if (Changed)
        return PreservedAnalyses::none();

    return PreservedAnalyses::all();
}

void DeleteDebugInfoPass::RemoveDebugRecords()
{
    if (!RecordsToRemove.empty())
        Changed = true;
    else
        Changed = false;

    for (DbgVariableRecord* dvr : RecordsToRemove)
        dvr->removeFromParent();
}

void DeleteDebugInfoPass::GetDebugRecords(Function& F)
{
    RecordsToRemove.clear();

    for (BasicBlock& BB: F) {
        for (Instruction& I: BB) {
            for (DbgVariableRecord &DVR : filterDbgVars(I.getDbgRecordRange())) {

                if (DVR.isDbgValue() || DVR.isDbgDeclare() || DVR.isDbgAssign()) RecordsToRemove.push_back(&DVR);

            }
        }
    }

}
