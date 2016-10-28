//
//  ViewController.m
//  02-socket获取数据
//
//  Created by 教师机 on 16/10/26.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "ViewController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
// 导入这三个框架 !!!!

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self socket];
    
    [self getBaidu];
}

- (void)getBaidu {
    
    // 1创建socket
    int socketId = socket(AF_INET, SOCK_STREAM, 0);
    // 2. 创建连接
    
    // 2.1
    struct sockaddr_in sockaddrIn ;
    // 2.2 设置协议
    sockaddrIn.sin_family = AF_INET;
    // 2.3 设置IP地址
    sockaddrIn.sin_addr.s_addr = inet_addr("119.75.217.109");
    // 2.4 设置端口
    sockaddrIn.sin_port = htons(80);
    
    int connectId = connect(socketId, (const struct sockaddr *)&sockaddrIn, sizeof(sockaddrIn));
    
    if (connectId == 0) {
        NSLog(@"创建成功了");
    } else {
        
        NSLog(@"创建失败");
        return;
    }
    
    // 3. 发送请求 -- 一行结束要加 \r\n
    // 最后一行要加 \r\n\r\n
    
    char *msg = "GET / HTTP/1.1\r\n"
    "Host: www.baidu.com\r\n"
    "User-Agent: iphone\r\n"
    "Connection: close\r\n\r\n";
    
    
    ssize_t sendLen = send(socketId, msg, strlen(msg), 0);
    
    // 4. 接收数据 -- 百度页面 > 1024个字节
    
    int8_t buffer[1024];
    
    // 接收多次
    
    ssize_t recvLen = 1;
    // 定义一个可变的data
    NSMutableData *dataM = [NSMutableData data];
    
    // 当接收的长度!=0的时候,表示还有数据要接收
    // 当长度=0的时候,表示都接收完了!
    while (recvLen != 0) {
        
      recvLen  = recv(socketId, buffer, sizeof(buffer), 0);
        // 把字节转换成data
        NSData *data = [[NSData alloc]initWithBytes:buffer length:recvLen];
        // 把转换的data 拼接到可变的 data里
        [dataM appendData:data];
    }
    
    // 把二进制转换成string
    NSString *html = [[NSString alloc]initWithData:dataM encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",html);
    // 5. 关闭
    close(socketId);
}

- (void)socket {
    
    // 1. 创建一个socket
    /*
     domain：协议域，又称协议族（family）。常用的协议族有AF_INET、AF_INET6、AF_LOCAL（或称AF_UNIX，Unix域Socket）、AF_ROUTE等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
     type：指定Socket类型。常用的socket类型有SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等。流式Socket（SOCK_STREAM）是一种面向连接的Socket，针对于面向连接的TCP服务应用。数据报式Socket（SOCK_DGRAM）是一种无连接的Socket，对应于无连接的UDP服务应用。
     protocol：指定协议。常用协议有IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC等，分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议。
     注意：1.type和protocol不可以随意组合，如SOCK_STREAM不可以跟IPPROTO_UDP组合。当第三个参数为0时，会自动选择第二个参数类型对应的默认协议。
     
        返回值(套接字描述符): 接下来会用到socket的返回值
     */
  int socketId = socket(AF_INET, SOCK_STREAM, 0);
    // 2. 创建一个连接
    /*
     参数
     参数一：套接字描述符
     参数二：指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     参数三：参数二sockaddr的长度，可以通过sizeof（struct sockaddr）获得
     返回值
     成功则返回0，失败返回非0，错误码GetLastError()。
     */
    
    // 2.1定义一个 sockaddr_in 类型的结构体
    struct sockaddr_in sockaddIn;
    // 2.2 设置协议 - AF_INET
    sockaddIn.sin_family = AF_INET;
    // 2.3 设置ip地址(域名)
    sockaddIn.sin_addr.s_addr = inet_addr("127.0.0.1");
    // 2.4 设置端口
    sockaddIn.sin_port = htons(12345);
    
   int connectId = connect(socketId, (const struct sockaddr *)&sockaddIn, sizeof(sockaddIn));
    
    if (connectId == 0) {
        NSLog(@"成功");
    } else {
        
        NSLog(@"失败");
        return;
    }
    // 3. 发送数据
    /*
        参数1:套接字描述符
        参数2: 发送的消息 字符串 C语言
        参数3: 字符串的长度
        参数4: 填写0
     */
    
    char *msg = "hello world";
    
   ssize_t sendLen = send(socketId, msg, strlen(msg), 0);
    
    NSLog(@"%zd",sendLen);
    // 4. 接收数据
    /*
     参数1: 套接字描述符
     参数2: 接收过来的数据 -- 定义一个数组去接收数据
     参数3: 数组的长度
     参数4: 填写0
     
     返回值: 就是接收数据的长度
     */

    int8_t buffer[1024];
    
    ssize_t recvLen = recv(socketId, buffer, sizeof(buffer), 0);
    
    // 将buffer里的数据转换成data
    NSData *data = [[NSData alloc]initWithBytes:buffer length:recvLen];
    
    // 将data转换成 字符串
    NSString *recvstr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",recvstr);
    
    // 5.关闭
    close(socketId);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
