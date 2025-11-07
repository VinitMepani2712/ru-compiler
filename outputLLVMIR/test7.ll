define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 3, ptr %b.alloc
    store i64 1, ptr %c.alloc
    %t1 = load i64, ptr %a.alloc
    %cmp = icmp ugt i64 %t1, 2
    br i1 %cmp, label %if.then, label %if.else
if.then:
    %t2 = load i64, ptr %a.alloc
    %t3 = mul i64 %t2, 2
    store i64 %t3, ptr %b.alloc
    br label %if.end
if.else:
    %t4 = load i64, ptr %a.alloc
    %t5 = add i64 %t4, 5
    store i64 %t5, ptr %b.alloc
    br label %if.end
if.end:
    br label %while.cond
while.cond:
    %1 = load i64, ptr %b.alloc
    %cmp1 = icmp ugt i64 %1, 4
    br i1 %cmp1, label %while.body, label %while.end
while.body:
    %t6 = load i64, ptr %c.alloc
    %t7 = load i64, ptr %b.alloc
    %t8 = add i64 %t6, %t7
    store i64 %t8, ptr %c.alloc
    %t9 = load i64, ptr %b.alloc
    %t10 = sub i64 %t9, 1
    store i64 %t10, ptr %b.alloc
    br label %while.cond
while.end:
    %t11 = load i64, ptr %c.alloc
    ret i64 %t11
}

