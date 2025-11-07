define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    %d.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 5, ptr %b.alloc
    store i64 0, ptr %c.alloc
    %t1 = load i64, ptr %a.alloc
    %t2 = add i64 %t1, 1
    store i64 %t2, ptr %d.alloc
    br label %while.cond
while.cond:
    %1 = load i64, ptr %d.alloc
    %cmp = icmp ugt i64 %1, 2
    br i1 %cmp, label %while.body, label %while.end
while.body:
    %t3 = load i64, ptr %b.alloc
    %t4 = load i64, ptr %a.alloc
    %t5 = add i64 %t3, %t4
    store i64 %t5, ptr %b.alloc
    %t6 = load i64, ptr %d.alloc
    %t7 = sub i64 %t6, 1
    store i64 %t7, ptr %d.alloc
    br label %while.cond
while.end:
    %t8 = load i64, ptr %b.alloc
    %cmp1 = icmp ugt i64 %t8, 10
    br i1 %cmp1, label %if.then, label %if.else
if.then:
    %t9 = load i64, ptr %b.alloc
    %t10 = sub i64 %t9, 3
    store i64 %t10, ptr %c.alloc
    br label %if.end
if.else:
    %t11 = load i64, ptr %b.alloc
    %t12 = add i64 %t11, 2
    store i64 %t12, ptr %c.alloc
    br label %if.end
if.end:
    %t13 = load i64, ptr %c.alloc
    ret i64 %t13
}

