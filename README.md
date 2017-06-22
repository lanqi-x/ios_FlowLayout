# flowLayout
自动换行view，仿tableView实现协议模式，可限制行数，来个图先

<img src="http://img.blog.csdn.net/20170622155726459?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGFucWlfeA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center" alt="" /><br />

# 函数：
<table border="1">
<tr>
<td>方法名</td>
<td>描述</td>	
<td>所属类</td>	
</tr>
<tr>
<td>-(void)reloadData</td>
<td>重新加载数据，前提是有设置delegate</td>	
<td>FlowLayout</td>	
</tr>
<tr>
<td>-(void)removeItemAtIndex:(NSInteger) index</td>
<td>移除指定位置的view，前提是有设置delegate</td>	
<td>FlowLayout</td>	
</tr>
<tr>
<td>-(void)changeItemAtIndex:(NSInteger) index</td>
<td>更改指定位置view的数据，前提是有设置delegate</td>	
<td>FlowLayout</td>	
</tr>
<tr>
<td>(void)insertItemAtIndex:(NSInteger) index</td>
<td>指定位置插入view，前提是有设置delegate</td>	
<td>FlowLayout</td>	
</tr>
<tr>
<td>- (instancetype)initWithSubViewList:(NSMutableArray *)subViewList</td>
<td>直接用view数组初始化FlowLayout </td>	
<td>FlowLayout</td>	
</tr>
</table>


# 属性
<table border="1">
<tr>
<td>属性</td>
<td>描述</td>	
<td>类型</td>	
</tr>
<tr>
<td>delegate</td>
<td>绑定数据协议，类TableView的协议，当比其简单，未实现view的复用</td>	
<td>id<FlowLayoutDelegate></td>	
</tr>
<tr>
<td>rowList</td>
<td>计算后每一行的view，只读</td>	
<td>NSMutableArray（NSMutableArray（UIView））</td>	
</tr>
<tr>
<td>rowHightList</td>
<td>计算后每一行的高度，只读</td>	
<td>NSMutableArray（CGFloat）</td>	
</tr>
<tr>
<td>horizontalSpace</td>
<td>view之间的横向间距</td>	
<td>CGFloat</td>	
</tr>
<tr>
<td>verticalSpace</td>
<td>每行的间距</td>	
<td>CGFloat</td>	
</tr>
<tr>
<td>subViewList</td>
<td>控件中所有的子view，只读</td>	
<td>NSMutableArray（UIView）</td>	
</tr>

<tr>
<td>fastenHeight</td>
<td>是否固定高度（默认为true，即你设置FlowLayout的高为多少就多少，设置为false则高度根据内容确定，调用sizeToFit函数也可以）</td>	
<td>bool</td>	
</tr>

<tr>
<td>lastShowIndex</td>
<td>FlowLayout中子view最后一个显示的角标，只读</td>	
<td>int</td>
</tr>

<tr>
<td>maxLine</td>
<td>显示最大行数（默认为int的最大值），最小为1</td>	
<td>int</td>
</tr>
</table>
