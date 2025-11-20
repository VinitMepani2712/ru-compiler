define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    %d.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    %t1 = load i64, ptr %a.alloc
    %t2 = add i64 %t1, 3
    store i64 %t2, ptr %b.alloc
    store i64 1, ptr %c.alloc
    %t3 = load i64, ptr %b.alloc
    %cmp = icmp ugt i64 %t3, 6
    br i1 %cmp, label %if.then, label %if.else

if.then:
    %t4 = load i64, ptr %b.alloc
    %t5 = sub i64 %t4, 2
    store i64 %t5, ptr %d.alloc
    br label %if.end

if.else:
    %t6 = load i64, ptr %b.alloc
    %t7 = add i64 %t6, 4
    store i64 %t7, ptr %d.alloc
    br label %if.end

if.end:
    br label %while.cond

while.cond:
    %t8 = load i64, ptr %d.alloc
    %cmp1 = icmp ugt i64 %t8, 3
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t9 = load i64, ptr %c.alloc
    %t10 = load i64, ptr %a.alloc
    %t11 = add i64 %t9, %t10
    store i64 %t11, ptr %c.alloc
    %t12 = load i64, ptr %d.alloc
    %t13 = sub i64 %t12, 2
    store i64 %t13, ptr %d.alloc
    br label %while.cond

while.end:
    %t14 = load i64, ptr %c.alloc
    ret i64 %t14
}
