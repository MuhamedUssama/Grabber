#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  
  // Set the initial window size to match lib/main.dart
  const int window_width = 1200;
  const int window_height = 700;

  // Calculate the center position of the primary monitor
  int screen_width = GetSystemMetrics(SM_CXSCREEN);
  int screen_height = GetSystemMetrics(SM_CYSCREEN);

  // Get the scaling factor for the primary monitor
  HDC hdc = GetDC(NULL);
  int dpi = GetDeviceCaps(hdc, LOGPIXELSX);
  ReleaseDC(NULL, hdc);
  double scale_factor = dpi / 96.0;

  // Calculate centered logical coordinates
  int x = (static_cast<int>(screen_width / scale_factor) - window_width) / 2;
  int y = (static_cast<int>(screen_height / scale_factor) - window_height) / 2;

  Win32Window::Point origin(x, y);
  Win32Window::Size size(window_width, window_height);

  if (!window.Create(L"Grabber", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
