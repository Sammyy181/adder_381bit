import serial

def read_uart(port: str, baud_rate: int = 9600):
    try:
        with serial.Serial(port, baud_rate, timeout=1) as ser:
            print(f"Listening on {port} at {baud_rate} baud...")
            while True:
                if ser.in_waiting > 0:
                    data = ser.readline()
                    binary_data = ' '.join(format(byte, '02X') for byte in data)
                    print(f"Received: {binary_data}")
    except serial.SerialException as e:
        print(f"Error: {e}")
    except KeyboardInterrupt:
        print("Exiting...")

if __name__ == "__main__":
    port = "COM4"  # Change this to your UART port (e.g., "/dev/ttyUSB0" on Linux)
    baud_rate = 9600  # Adjust according to your setup
    read_uart(port, baud_rate)

