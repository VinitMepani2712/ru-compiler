define i64 @foo(i64 %a) {
entry:
    %cmp = icmp ugt i64 %a, 10
    br i1 %cmp, label %if.then, label %if.else

if.then:
    br label %if.end

if.else:
    br label %if.end

if.end:
    %b.alloc.0 = phi i64 [ 20, %if.then ], [ 5, %if.else ]
    br label %while.cond

while.cond:
    %c.alloc.0 = phi i64 [ 0, %if.end ], [ %t2, %while.body ]
    %d.alloc.0 = phi i64 [ 0, %if.end ], [ %t1, %while.body ]
    %cmp1 = icmp ult i64 %c.alloc.0, %b.alloc.0
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t1 = add i64 %d.alloc.0, 2
    %t2 = add i64 %c.alloc.0, 1
    br label %while.cond

while.end:
    ret i64 %c.alloc.0
}
