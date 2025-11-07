define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    %t1 = load i64, ptr %a.alloc
    %t2 = add i64 %t1, 4
    store i64 %t2, ptr %b.alloc
    store i64 2, ptr %c.alloc
    %t3 = load i64, ptr %b.alloc
    %cmp = icmp ult i64 %t3, 8
    br i1 %cmp, label %if.then, label %if.else
if.then:
    %t4 = load i64, ptr %b.alloc
    %t5 = add i64 %t4, 2
    store i64 %t5, ptr %b.alloc
    br label %if.end
if.else:
    %t6 = load i64, ptr %b.alloc
    %t7 = sub i64 %t6, 3
    store i64 %t7, ptr %b.alloc
    br label %if.end
if.end:
    br label %while.cond
while.cond:
    %1 = load i64, ptr %b.alloc
    %cmp1 = icmp ugt i64 %1, 4
    br i1 %cmp1, label %while.body, label %while.end
while.body:
    %t8 = load i64, ptr %c.alloc
    %t9 = load i64, ptr %b.alloc
    %t10 = add i64 %t8, %t9
    store i64 %t10, ptr %c.alloc
    %t11 = load i64, ptr %b.alloc
    %t12 = sub i64 %t11, 2
    store i64 %t12, ptr %b.alloc
    br label %while.cond
while.end:
    %t13 = load i64, ptr %c.alloc
    ret i64 %t13
}

