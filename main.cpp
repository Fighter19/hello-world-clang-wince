// Signature of AfxMessageBox (for Unicode)
int __cdecl AfxMessageBox(wchar_t const *,unsigned int,unsigned int);

// This would be the normal user-defined entrypoint
//int wWinMain()

// This entry point is defined by the linker and usually points to C runtime startup code
int wWinMainCRTStartup()
{
	// Find a string and add/remove so many characters,
	// Until IMAGE_IMPORT_DESCRIPTOR is 8-byte aligned
	AfxMessageBox(L"Load Success!   \n", 0, 0);
	return 0;
}
