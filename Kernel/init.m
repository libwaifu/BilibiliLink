If[$CharacterEncoding=!="UTF-8",
    $CharacterEncoding="UTF-8";
    Print[{
        Style["$CharacterEncoding has changed to UTF-8 to avoid problems.",Red],
        Style["Because BilibiliLink only works under UTF-8"]
    }//TableForm];
    st=OpenAppend[FindFile["init.m"]];
    WriteString[st,"$CharacterEncoding=\"UTF-8\";"];
    Close[st];
];
Get["BilibiliLink`BilibiliLink`"];