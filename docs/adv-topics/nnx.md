# Node Number Extensions (NNX)
A Node Number Extension is a method to expand any issued node number to as many as ten node numbers. The reasons for this are to allow users to assign themselves sequential node numbers while preserving and expanding valuable node number space. The concept is very simple, allow users to optionally expand the length of any of their node numbers by one digit.

## NNX Example
When a user with an existing node number selects to extend the number, they go to the portal and select to **Extend** a node, rather than **Request** a new node. The portal converts node xxxxx to xxxxx0 and adds node xxxx1 to the user’s node list. An additional eight NNX nodes may be added for a total of 10 sequential (xxxxx0 thru xxxxx9) node numbers. The reason xxxxx has to be changed to xxxxx0 is because AllStarLink would connect to node xxxxx when attempting to dial node xxxx1.

Example:

```
Initial Node:                       63001
NNX Conversion:                     63001 --> 630010
NNX Node Pool:                      630010 to 630019
```

Once the node user has reconfigured their node computer (if previously registered as xxxxx), both node numbers register, show on the AllStar nodes list, show on stats page, appear in [Allmon3](../allmon3/index.md) and of course can connect or be connected to.   

!!! note "First Time Registration"
    New users that have not yet been issued a node number would **Request** their initial node number first. Then you can **Extend** the issued node number to allow up to ten nodes to be created. See the [Getting Started](../basics/gettingstarted.md) section of the manual for information on requesting your initial node number.

## Requirements
Use of NNX node numbers is totally optional, but strongly recommended. The prior node request process still exists. Existing and new users may continue to request new node numbers per current policy.

Users who opt to expand an existing node number will need to make configuration changes to their existing node (if configured). That is (using the example numbers above) all references to node 63001 will need to change to 630010. Fortunately, the [`asl-menu`](../user-guide/index.md) "Node Settings" menu allows you to change a node number, updating rpt.conf, rpt_http_registrations.conf, simpleusb.conf, usbradio.conf, voter.conf, extensions.conf, and allmon3.ini (if using [Allmon3](../allmon3/config.md)). Reconfiguring all occurrences of the existing node number is critical. Such an oversight may confuse users and put an extra support load on system admins, at least initially.

!!! note "New Node Setup"
    If you are registering for a node number for the first time, it would be wise to extend your node number before you configure your new node for the first time. That way, you can have your xxxxx0 number ready to deploy, without having to reconfigure it after the fact. It also sets you up to easily deploy additional nodes, as your extended node numbers will already be available.

Adding NNX nodes xxxxx1 thru xxxxx9 is the same process as adding any additional node.  

## NNX on the AllStarLink Portal
Node Number Extension implementation on the AllStarLink Portal is shown below.
  
### Request Initial Node Number
Before you can complete Node Number Extension, you need an Initial Node Number. See the [Getting Started](../basics/gettingstarted.md) page for instructions on how to request your Initial Node Number.

### Extend a Node Number
Log in to the [AllStarLink Portal](https://www.allstarlink.org/portal) with your user credentials. From the **Portal** menu, choose **Node Settings**.

![Step 1 Node Settings](img/1_NNX_Node_Settings.png){width="400"}

You will see your current assigned nodes. Click **Continue** to proceed.

![Step 2 Node Settings Continue](img/2_NNX_Continue.png){width="400"}

Ensure **Extend** is in bold (the currently selected tab), pick the node you want to extend from the drop down menu, then click **Continue**.

![Step 3 Select Node](img/3_NNX_Extend_Continue.png){width="400"}

Confirm that you indeed want to proceed with extending your node number.

![Step 4 Proceed](img/4_NNX_Extend_Confirm.png){width="400"}

You should see a **Success** message when your node has successfully been extended. Click **OK** to continue.

![Step 5 Success](img/5_NNX_Success.png){width="400"}

You will be returned to your Nodes page, showing your available node numbers. You should now see that you Initial Node Number has been extended (adding a `0` on the end), and a new node ending in `1` has also been created.

![Step 6 New NNX](img/6_NNX_New_Nodes.png){width="400"}

At this point, you can modify each node as desired. You can re-assign them to different servers, as well as modify their individual node parameters by clicking on the node number. You can now proceed with configuring your node on your actual server, using the [ASL3 Menu](../user-guide/index.md) to complete your `Node Setup`. 

If you wish to create additional nodes, see the next section.

### Add an Additional NNX Node
From the **Node Settings** page, click **Continue** to open the **Extend/Request/Remove** page.

![Step 1 New NNX](img/6_NNX_New_Nodes.png){width="400"}

To add another NNX Node, ensure you are on the **Extend** tab (it will be bold), choose the node you wish to add an additional NNX to from the drop down menu, then click **Continue**.

![Step 2 Add New NNX](img/7_NNX_Add.png){width="400"}

On the following screen, click **Submit** to add the next NNX in sequence.

![Step 3 Add NNX Confirmation](img/8_NNX_Add_Confirm.png){width="400"}

You should see a **Success** message when your additional node has been added. Click **OK** to continue.

![Step 4 Add NNX Success](img/9_NNX_Add_Success.png){width="400"}

You will be returned to your Nodes page, your new NNX node number will now appear in your Nodes List.

![Step 5 New NNX Nodes List](img/10_NNX_New_Nodes.png){width="400"}

At this point, you can modify each node as desired. You can re-assign them to different servers, as well as modify their individual node parameters by clicking on the node number. You can now proceed with configuring your node on your actual server, using the [ASL3 Menu](../user-guide/index.md) to complete your `Node Setup`.

### Revert a NNX Back to an INN
Should you decide that you no longer want to use extended node numbers, you can revert back from NNX to a base node number (Initial Node Number).

!!! warning "Deletes All NNX Nodes!!"
    Be warned, proceeding to revert your NNX node back to a base node number **will delete all NNX node numbers**. 

From the **Node Settings** page, click **Continue** to open the **Extend/Request/Remove** page.

![Step 1 NNX Node List](img/6_NNX_New_Nodes.png){width="400"}

To revert your node, ensure you are on the **Remove** tab (it will be bold), choose the node you wish to revert, then click **Continue**.

![Step 2 NNX Remove](img/11_NNX_Revert.png){width="400"}

Next, you need to confirm that this is indeed what you want to do.

![Step 3 NNX Remove Confirm](img/12_NNX_Revert_Confirm.png){width="400"}

You should see a **Success** message when your node has been reverted, and all your NNX nodes have been removed.

![Step 3 NNX Remove Success](img/13_NNX_Revert_Success.png){width="400"}

You will be returned to your Nodes page, and your base node number will now appear in your Nodes List.

![Step 4 NNX Remove Nodes](img/14_NNX_Revert_Nodes.png){width="400"}

### Delete a Base Node Number
If you wish to delete a node entirely from your account, follow the process below.

!!! warning "This Will Delete Your Node!"
    This process will delete your node entirely from the AllStarLink database, and return your node number to the pool for re-assignment.

From the **Node Settings** page, click **Continue** to open the **Extend/Request/Remove** page.

![Step 1 Remove Node](img/14_NNX_Revert_Nodes.png){width="400"}

To delete your node, ensure you are on the **Remove** tab (it will be bold), choose the node you wish to delete, then click **Continue**.

![Step 2 Remove Node Continue](img/15_NNX_Delete_Primary.png){width="400"}

Next, you will need to confirm that this is indeed what you want to do.

![Step 3 Confirm Delete](img/17_Delete_Primary.png){width="400"}

At this point, you need to ensure that you wipe the configuration from any server that had this node number configured, as it will continue trying to register with AllStarLink, providing unnecessary strain on our resources.

