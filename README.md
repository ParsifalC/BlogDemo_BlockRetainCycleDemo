# BlockRetainCycleDemo
block使用中常见的retain cycle现象以及解决方式。
比较保险的做法是：在block里面引用持有者，就进行weakObj/strongObj组合。
