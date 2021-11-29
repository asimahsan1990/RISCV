import re

f = open("code_file_source", "r")
wirte_file=open("hex_file_write.hex","w")
for line in f:
    a=line
    a=a.split(':')
    i=a[1].split()
    #print(a[0])
    print(a[1])
    print(i[0][6],i[0][7],i[0][4],i[0][5],i[0][2],i[0][3],i[0][0],i[0][1])
    #print(i[0][7],i[0][5],i[0][6],i[0][3],i[0][4],i[0][1],i[0][2])
    #a=a[].replace("\t", "")
    temp_wrt=i[0][6]+i[0][7]+" "+i[0][4]+i[0][5]+" "+i[0][2]+i[0][3]+" "+i[0][0]+i[0][1]+"// "+a[1]
    wirte_file.write(temp_wrt)
    #print(line)