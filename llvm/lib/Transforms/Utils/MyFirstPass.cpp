#include "llvm/Transforms/Utils/MyFirstPass.h"
#include "llvm/IR/Function.h"

using namespace llvm;

PreservedAnalyses MyFirstPass::run(Function& F, FunctionAnalysisManager& AM)
{
    errs() << "Function: " << F.getName() << "\n";

    return PreservedAnalyses::all();
}
