# PCA-Viewer
Tool grid view che analizza PcaAppLaunchDic.txt segnando Path, Timestamp e Signatures

# Come eseguire il tool:
CMD (admin):
```
powershell -ExecutionPolicy Bypass -Command "& { $p = \"$env:TEMP\PCA-Viewer.ps1\"; iwr 'https://raw.githubusercontent.com/sandydll-bs/PCA-Viewer/main/PCA-Viewer.ps1' -OutFile $p; Start-Process powershell -Verb RunAs -ArgumentList @('-NoExit','-ExecutionPolicy','Bypass','-File',$p) }"
