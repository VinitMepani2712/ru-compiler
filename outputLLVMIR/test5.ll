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
    %t3 = load i64, ptr %d.alloc
    %cmp = icmp ugt i64 %t3, 2
    br i1 %cmp, label %while.body, label %while.end

while.body:
    %t4 = load i64, ptr %b.alloc
    %t5 = load i64, ptr %a.alloc
    %t6 = add i64 %t4, %t5
    store i64 %t6, ptr %b.alloc
    %t7 = load i64, ptr %d.alloc
    %t8 = sub i64 %t7, 1
    store i64 %t8, ptr %d.alloc
    br label %while.cond

while.end:
    %t9 = load i64, ptr %b.alloc
    %cmp1 = icmp ugt i64 %t9, 10
    br i1 %cmp1, label %if.then, label %if.else

if.then:
    %t10 = load i64, ptr %b.alloc
    %t11 = sub i64 %t10, 3
    store i64 %t11, ptr %c.alloc
    br label %if.end

if.else:
    %t12 = load i64, ptr %b.alloc
    %t13 = add i64 %t12, 2
    store i64 %t13, ptr %c.alloc
    br label %if.end

if.end:
    %t14 = load i64, ptr %c.alloc
    ret i64 %t14
}
