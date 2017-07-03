removeAllPersonFolder
for i = 1:23    
    if(i < 10)
        path=strcat('../img/g00',num2str(i));
    else
        path=strcat('../img/g0',num2str(i));
    end
    classifyPersons
end