Add-PSSnapIn Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue 

Copy-Item -Path "C:\HydrationW8\Source\DS" -Destination "C:\HydrationW8" -Recurse -Verbose -Force
Copy-Item -Path "C:\HydrationW8\Source\ISO\Control" -Destination "C:\HydrationW8\ISO\Content\Deploy" -Recurse -Verbose -Force
