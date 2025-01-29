; RUN: opt -disable-output -passes=myfirstpass %s 2>&1 | FileCheck %s

; CHECK: {{^}}Function: foo{{$}}
define i32 @foo() {
%a = add i32 2, 3
  ret i32 %a
}

; CHECK-NEXT: {{^}}Function: bar{{$}}
define void @bar() {
  ret void
}
