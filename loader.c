#include <windows.h>
int _cdecl main(void)
{
    HANDLE hSCManager;
    HANDLE hService;
    SERVICE_STATUS ss;

    hSCManager = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
    
    printf("Load Driver\n");

    if(hSCManager)
    {
        printf("Create Service\n");

        hService = CreateService(hSCManager, "Example", 
                                 "Example Driver", 
                                  SERVICE_START | DELETE | SERVICE_STOP, 
                                  SERVICE_KERNEL_DRIVER,
                                  SERVICE_DEMAND_START, 
                                  SERVICE_ERROR_IGNORE, 
                                  "C:\\example.sys", 
                                  NULL, NULL, NULL, NULL, NULL);

        if(!hService)
        {
            hService = OpenService(hSCManager, "Example", 
                       SERVICE_START | DELETE | SERVICE_STOP);
        }

        if(hService)
        {
            printf("Start Service\n");

            StartService(hService, 0, NULL);
            printf("Press Enter to close service\r\n");
            getchar();
            ControlService(hService, SERVICE_CONTROL_STOP, &ss);

            DeleteService(hService);

            CloseServiceHandle(hService);
            
        }

        CloseServiceHandle(hSCManager);
    }
    
    return 0;
}

