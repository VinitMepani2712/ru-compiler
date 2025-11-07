define i64 @foo(i64 %a) {
entry:
    %t1 = add i64 %a, 3
    %cmp = icmp ugt i64 %t1, 6
    br i1 %cmp, label %if.then, label %if.else

if.then:
    %t2 = sub i64 %t1, 2
    br label %if.end

if.else:
    %t3 = add i64 %t1, 4
    br label %if.end

if.end:
    %d.alloc.0 = phi i64 [ %t2, %if.then ], [ %t3, %if.else ]
    br label %while.cond

while.cond:
    %c.alloc.0 = phi i64 [ 1, %if.end ], [ %t4, %while.body ]
    %d.alloc.1 = phi i64 [ %d.alloc.0, %if.end ], [ %t5, %while.body ]
    %cmp1 = icmp ugt i64 %d.alloc.1, 3
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t4 = add i64 %c.alloc.0, %a
    %t5 = sub i64 %d.alloc.1, 2
    br label %while.cond

while.end:
    ret i64 %c.alloc.0
}
