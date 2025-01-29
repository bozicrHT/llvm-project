; RUN: opt -disable-output -passes=mydebug-pass %s 2>&1 | FileCheck %s
; ModuleID = 'fib.c'
source_filename = "fib.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [17 x i8] c"fib(09) --> %ld\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [17 x i8] c"fib(11) --> %ld\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [17 x i8] c"fib(20) --> %ld\0A\00", align 1, !dbg !9

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @fib(i32 noundef %n) #0 !dbg !21 {
entry:
  %n.addr = alloca i32, align 4
  %p = alloca i64, align 8
  %c = alloca i64, align 8
  %f = alloca i64, align 8
  %i = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
    ; CHECK-NOT: #dbg_declare(ptr %n.addr, !27, !DIExpression(), !28)
    ; CHECK-NOT: #dbg_declare(ptr %p, !29, !DIExpression(), !30)
  store i64 0, ptr %p, align 8, !dbg !30
    ; CHECK-NOT: #dbg_declare(ptr %c, !31, !DIExpression(), !32)
  store i64 1, ptr %c, align 8, !dbg !32
    ; CHECK-NOT: #dbg_declare(ptr %f, !33, !DIExpression(), !34)
  %0 = load i64, ptr %p, align 8, !dbg !35
  %1 = load i64, ptr %c, align 8, !dbg !36
  %add = add nsw i64 %0, %1, !dbg !37
  store i64 %add, ptr %f, align 8, !dbg !34
    ; CHECK-NOT: #dbg_declare(ptr %i, !38, !DIExpression(), !40)
  store i32 3, ptr %i, align 4, !dbg !40
  br label %for.cond, !dbg !41

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, ptr %i, align 4, !dbg !42
  %3 = load i32, ptr %n.addr, align 4, !dbg !44
  %cmp = icmp sle i32 %2, %3, !dbg !45
  br i1 %cmp, label %for.body, label %for.end, !dbg !46

for.body:                                         ; preds = %for.cond
  %4 = load i64, ptr %c, align 8, !dbg !47
  store i64 %4, ptr %p, align 8, !dbg !49
  %5 = load i64, ptr %f, align 8, !dbg !50
  store i64 %5, ptr %c, align 8, !dbg !51
  %6 = load i64, ptr %p, align 8, !dbg !52
  %7 = load i64, ptr %c, align 8, !dbg !53
  %add1 = add nsw i64 %6, %7, !dbg !54
  store i64 %add1, ptr %f, align 8, !dbg !55
  br label %for.inc, !dbg !56

for.inc:                                          ; preds = %for.body
  %8 = load i32, ptr %i, align 4, !dbg !57
  %inc = add nsw i32 %8, 1, !dbg !57
  store i32 %inc, ptr %i, align 4, !dbg !57
  br label %for.cond, !dbg !58, !llvm.loop !59

for.end:                                          ; preds = %for.cond
  %9 = load i64, ptr %f, align 8, !dbg !62
  ret i64 %9, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !64 {
entry:
  %retval = alloca i32, align 4
  %a = alloca i64, align 8
  %b = alloca i64, align 8
  store i32 0, ptr %retval, align 4
    ; CHECK-NOT: #dbg_declare(ptr %a, !67, !DIExpression(), !68)
  %call = call i64 @fib(i32 noundef 9), !dbg !69
  store i64 %call, ptr %a, align 8, !dbg !68
  %0 = load i64, ptr %a, align 8, !dbg !70
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %0), !dbg !71
  %call2 = call i64 @fib(i32 noundef 11), !dbg !72
  store i64 %call2, ptr %a, align 8, !dbg !73
  %1 = load i64, ptr %a, align 8, !dbg !74
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i64 noundef %1), !dbg !75
    ; CHECK-NOT: #dbg_declare(ptr %b, !76, !DIExpression(), !77)
  %call4 = call i64 @fib(i32 noundef 20), !dbg !78
  store i64 %call4, ptr %b, align 8, !dbg !77
  %2 = load i64, ptr %b, align 8, !dbg !79
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i64 noundef %2), !dbg !80
  ret i32 0, !dbg !81
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 20, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "fib.c", directory: "/home/radovan/llvm-project/build", checksumkind: CSK_MD5, checksum: "990a185f3730d6c93ca63088968201ad")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 17)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 22, type: !3, isLocal: true, isDefinition: true)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(scope: null, file: !2, line: 24, type: !3, isLocal: true, isDefinition: true)
!11 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "clang version 20.0.0git (https://github.com/radovan-bozic/llvm-project.git b7286dbef9dc1986860d29e390b092599e1d7db5)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !12, splitDebugInlining: false, nameTableKind: None)
!12 = !{!0, !7, !9}
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 8, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 2}
!19 = !{i32 7, !"frame-pointer", i32 2}
!20 = !{!"clang version 20.0.0git (https://github.com/radovan-bozic/llvm-project.git b7286dbef9dc1986860d29e390b092599e1d7db5)"}
!21 = distinct !DISubprogram(name: "fib", scope: !2, file: !2, line: 3, type: !22, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !26)
!22 = !DISubroutineType(types: !23)
!23 = !{!24, !25}
!24 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{}
!27 = !DILocalVariable(name: "n", arg: 1, scope: !21, file: !2, line: 3, type: !25)
!28 = !DILocation(line: 3, column: 14, scope: !21)
!29 = !DILocalVariable(name: "p", scope: !21, file: !2, line: 5, type: !24)
!30 = !DILocation(line: 5, column: 10, scope: !21)
!31 = !DILocalVariable(name: "c", scope: !21, file: !2, line: 5, type: !24)
!32 = !DILocation(line: 5, column: 17, scope: !21)
!33 = !DILocalVariable(name: "f", scope: !21, file: !2, line: 6, type: !24)
!34 = !DILocation(line: 6, column: 10, scope: !21)
!35 = !DILocation(line: 6, column: 14, scope: !21)
!36 = !DILocation(line: 6, column: 18, scope: !21)
!37 = !DILocation(line: 6, column: 16, scope: !21)
!38 = !DILocalVariable(name: "i", scope: !39, file: !2, line: 8, type: !25)
!39 = distinct !DILexicalBlock(scope: !21, file: !2, line: 8, column: 5)
!40 = !DILocation(line: 8, column: 14, scope: !39)
!41 = !DILocation(line: 8, column: 10, scope: !39)
!42 = !DILocation(line: 8, column: 21, scope: !43)
!43 = distinct !DILexicalBlock(scope: !39, file: !2, line: 8, column: 5)
!44 = !DILocation(line: 8, column: 26, scope: !43)
!45 = !DILocation(line: 8, column: 23, scope: !43)
!46 = !DILocation(line: 8, column: 5, scope: !39)
!47 = !DILocation(line: 9, column: 13, scope: !48)
!48 = distinct !DILexicalBlock(scope: !43, file: !2, line: 8, column: 34)
!49 = !DILocation(line: 9, column: 11, scope: !48)
!50 = !DILocation(line: 10, column: 13, scope: !48)
!51 = !DILocation(line: 10, column: 11, scope: !48)
!52 = !DILocation(line: 11, column: 13, scope: !48)
!53 = !DILocation(line: 11, column: 17, scope: !48)
!54 = !DILocation(line: 11, column: 15, scope: !48)
!55 = !DILocation(line: 11, column: 11, scope: !48)
!56 = !DILocation(line: 12, column: 5, scope: !48)
!57 = !DILocation(line: 8, column: 30, scope: !43)
!58 = !DILocation(line: 8, column: 5, scope: !43)
!59 = distinct !{!59, !46, !60, !61}
!60 = !DILocation(line: 12, column: 5, scope: !39)
!61 = !{!"llvm.loop.mustprogress"}
!62 = !DILocation(line: 14, column: 12, scope: !21)
!63 = !DILocation(line: 14, column: 5, scope: !21)
!64 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 17, type: !65, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !26)
!65 = !DISubroutineType(types: !66)
!66 = !{!25}
!67 = !DILocalVariable(name: "a", scope: !64, file: !2, line: 19, type: !24)
!68 = !DILocation(line: 19, column: 10, scope: !64)
!69 = !DILocation(line: 19, column: 14, scope: !64)
!70 = !DILocation(line: 20, column: 33, scope: !64)
!71 = !DILocation(line: 20, column: 5, scope: !64)
!72 = !DILocation(line: 21, column: 9, scope: !64)
!73 = !DILocation(line: 21, column: 7, scope: !64)
!74 = !DILocation(line: 22, column: 33, scope: !64)
!75 = !DILocation(line: 22, column: 5, scope: !64)
!76 = !DILocalVariable(name: "b", scope: !64, file: !2, line: 23, type: !24)
!77 = !DILocation(line: 23, column: 10, scope: !64)
!78 = !DILocation(line: 23, column: 14, scope: !64)
!79 = !DILocation(line: 24, column: 33, scope: !64)
!80 = !DILocation(line: 24, column: 5, scope: !64)
!81 = !DILocation(line: 27, column: 5, scope: !64)
