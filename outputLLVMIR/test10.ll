define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    %t1 = load i64, ptr %a.alloc
    %t2 = add i64 %t1, 2
    store i64 %t2, ptr %b.alloc
    store i64 0, ptr %c.alloc
    br label %while.cond
while.cond:
    %1 = load i64, ptr %b.alloc
    %cmp = icmp ugt i64 %1, 2
    br i1 %cmp, label %while.body, label %while.end
while.body:
    %t3 = load i64, ptr %c.alloc
    %t4 = load i64, ptr %a.alloc
    %t5 = add i64 %t3, %t4
    store i64 %t5, ptr %c.alloc
    %t6 = load i64, ptr %b.alloc
    %t7 = sub i64 %t6, 1
    store i64 %t7, ptr %b.alloc
    br label %while.cond
while.end:
    %t8 = load i64, ptr %c.alloc
    %cmp1 = icmp ult i64 %t8, 5
    br i1 %cmp1, label %if.then, label %if.else
if.then:
    %t9 = load i64, ptr %c.alloc
    %t10 = add i64 %t9, 1
    store i64 %t10, ptr %c.alloc
    br label %if.end
if.else:
    %t11 = load i64, ptr %c.alloc
    store i64 %t11, ptr %c.alloc
    br label %if.end
if.end:
    %t12 = load i64, ptr %c.alloc
    ret i64 %t12
}

