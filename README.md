# modernie-winrm
This Vagrantfile is able to configure WinRM automatically on the box distributed by [Microsoft](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/). In other words this Vagrantfile is able to:
* Disable firewall (the box distributed by Microsoft is configured with firewall enabled by default);
* Change Network location type to "Work network" (the box distributed by Microsoft is configured as "Public network" by default);
* Enable WinRM.

It was tested only Win10-Stable-MSEdge and Win7-IE11 box provided by [Microsoft](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/).

<a href='https://pledgie.com/campaigns/33109'><img alt='Click here to lend your support to: modernie-winrm and make a donation at pledgie.com !' src='https://pledgie.com/campaigns/33109.png?skin_name=chrome' border='0' ></a>

# Instalation
```
mkdir c:\mybox && cd c:\mybox
```

```
git clone https://github.com/danielmenezesbr/modernie-winrm.git .
```

For **IE11-Win7** download the box and unzip it into c:\mybox. If you have curl and [7z](http://www.7-zip.org), you can do:
```
curl -LOk http://aka.ms/ie11.win7.vagrant
```

```
7z e ie11.win7.vagrant
```

For **MSEdge-Win10-Stable** download the box and unzip it into c:\mybox. If you have curl and [7z](http://www.7-zip.org), you can do:
```
curl -LOk http://aka.ms/msedge.win10.vagrant
```

```
7z e msedge.win10.vagrant
```

Just for MSEdge-Win10-Stable needs change Vagrantfile as bellow:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/win10vagrantfilecomment.png?raw=true)



First time you need to execute "vagrant up" twice.
```
vagrant up && vagrant up
```
# Demo
[Show animated gif](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/demo.gif?raw=true)

# Screenshots
Configuration changed after provisioning.

Network location type:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/network_category.png?raw=true)

Firewall status:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/firewall1.png?raw=true)

WinRM:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/firewall2.png?raw=true)

# Releases
[Check here!](https://github.com/danielmenezesbr/modernie-winrm/releases)
