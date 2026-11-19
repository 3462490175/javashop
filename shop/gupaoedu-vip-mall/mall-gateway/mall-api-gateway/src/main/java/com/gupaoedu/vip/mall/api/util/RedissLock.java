package com.gupaoedu.vip.mall.api.util;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RedissLock {


    /***
     * 创建RedissonClient对象
     *      创建锁、解锁
     * @return
     */
    @Bean
    public RedissonClient redissonClient(){
        //创建Config
        Config config = new Config();
        //本机单机模式（原课程为 7001-7006 集群，本机只有一个 Redis）
        config.useSingleServer()
                .setAddress("redis://127.0.0.1:6379");
        //创建RedissonClient
        return Redisson.create(config);
    }
}
