define i64 @foo(i64 %a) {
entry:
    %t1 = add i64 %a, 1
    br label %while.cond

while.cond:
    %b.alloc.0 = phi i64 [ 5, %if.end ], [ %t2, %while.body ]
    %d.alloc.0 = phi i64 [ %t1, %if.end ], [ %t3, %while.body ]
    %cmp = icmp ugt i64 %d.alloc.0, 2
    br i1 %cmp, label %while.body, label %while.end

while.body:
    %t2 = add i64 %b.alloc.0, %a
    %t3 = sub i64 %d.alloc.0, 1
    br label %while.cond

while.end:
    %cmp1 = icmp ugt i64 %b.alloc.0, 10
    br i1 %cmp1, label %if.then, label %if.else

if.then:
    %t4 = sub i64 %b.alloc.0, 3
    br label %if.end

if.else:
    %t5 = add i64 %b.alloc.0, 2
    br label %if.end

if.end:
    %c.alloc.0 = phi i64 [ %t4, %if.then ], [ %t5, %if.else ]
    ret i64 %c.alloc.0
}
