removeAllPersonFolder
for i = 1:23    
    i
    if(i < 10)
        path=strcat('../img/g00',num2str(i));
    else
        path=strcat('../img/g0',num2str(i));
    end
    s1classifyPersons
end