define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 4, ptr %b.alloc
    store i64 0, ptr %c.alloc
    br label %while.cond
while.cond:
    %1 = load i64, ptr %a.alloc
    %cmp = icmp ult i64 %1, 6
    br i1 %cmp, label %while.body, label %while.end
while.body:
    %t1 = load i64, ptr %c.alloc
    %t2 = load i64, ptr %a.alloc
    %t3 = add i64 %t1, %t2
    store i64 %t3, ptr %c.alloc
    %t4 = load i64, ptr %a.alloc
    %t5 = add i64 %t4, 1
    store i64 %t5, ptr %a.alloc
    br label %while.cond
while.end:
    %t6 = load i64, ptr %c.alloc
    %cmp1 = icmp ugt i64 %t6, 8
    br i1 %cmp1, label %if.then, label %if.else
if.then:
    %t7 = load i64, ptr %c.alloc
    %t8 = sub i64 %t7, 2
    store i64 %t8, ptr %c.alloc
    br label %if.end
if.else:
    %t9 = load i64, ptr %c.alloc
    store i64 %t9, ptr %c.alloc
    br label %if.end
if.end:
    %t10 = load i64, ptr %c.alloc
    ret i64 %t10
}

