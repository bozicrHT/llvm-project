#include "llvm/Transforms/Utils/DebugPass.h"
#include "llvm/IR/Function.h"

#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/DebugProgramInstruction.h"
#include "llvm/IR/Instruction.h"

using namespace llvm;

PreservedAnalyses DebugPass::run(Function& F, FunctionAnalysisManager& AM)
{
    CountRecords(F);

    return PreservedAnalyses::all();
}

void DebugPass::CountRecords(Function& F)
{
    errs() << "Function: " << F.getName() << "\n";

    RecordsMap.clear();

    for (BasicBlock& BB: F) {
        for (Instruction& I : BB) {

            for (DbgVariableRecord &DVR : filterDbgVars(I.getDbgRecordRange())) {
                if (DVR.isDbgValue())
                    RecordsMap["dbg_value"]++;
                if (DVR.isDbgDeclare())
                    RecordsMap["dbg_declare"]++;
                if (DVR.isDbgAssign())
                    RecordsMap["dbg_assing"]++;
            }

        }
    }

    for (const auto& p : RecordsMap)
        errs() << "    " << p.first << ": " << p.second << "\n";
}
