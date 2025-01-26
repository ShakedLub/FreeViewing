classdef XMLHandler < handle       
    properties (Access = private)
        gui_xml_file = [];
        xml_dom = [];
        exp_uicontrols_node = [];
        common_uicontrols_node = [];
    end
    
    methods (Access = public)
        function obj = XMLHandler(gui_xml_file, exp_uicontrols_node_name, common_uicontrols_node_name)
            obj.gui_xml_file = gui_xml_file;
            obj.xml_dom= xmlread(gui_xml_file);
            obj.exp_uicontrols_node = obj.xml_dom.getElementsByTagName(exp_uicontrols_node_name).item(0);
            obj.common_uicontrols_node = obj.xml_dom.getElementsByTagName(common_uicontrols_node_name).item(0);
        end
        
        function saveExpValueByNodeName(obj, node_name, value)            
            if numel(value)>1
                XMLHandler.saveDoubleVecValueByNodeName(obj.exp_uicontrols_node, node_name, value);
            else
                XMLHandler.saveDoubleValueByNodeName(obj.exp_uicontrols_node, node_name, value);
            end                                    
        end 
        
        function saveCommonValueByNodeName(obj, node_name, value)            
            if numel(value)>1
                XMLHandler.saveDoubleVecValueByNodeName(obj.common_uicontrols_node, node_name, value);
            else
                XMLHandler.saveDoubleValueByNodeName(obj.common_uicontrols_node, node_name, value);
            end                                            
        end 
        
        function saveXML(obj)
            myXMLwrite(obj.gui_xml_file, obj.xml_dom);
            disp('saved !');
        end
    end
    
    methods (Access = private, Static)
        function saveDoubleValueByNodeName(uicontrols_nodes_group, node_name, value)
            node= uicontrols_nodes_group.getElementsByTagName(node_name).item(0);
            node.getElementsByTagName('VALUE').item(0).setTextContent(num2str(value));
        end
        
        function saveDoubleVecValueByNodeName(uicontrols_nodes_group, node_name, vec)
            node= uicontrols_nodes_group.getElementsByTagName(node_name).item(0);
            data_str= sprintf('%f ',vec);
            data_str= data_str(1:end-1);
            node.getElementsByTagName('VALUE').item(0).setTextContent(num2str(data_str));
        end
    end    
end

