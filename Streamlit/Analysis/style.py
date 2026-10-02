# css for header
def headerStyle(header):
    return f"""
        <div style='color:#e3e3e3; font-size:2rem;
        text-align: center; font-family: Arial;
        font-weight: 600;'>
            🍕{header}
        </div>
    """


# css for subheader
def subHeaderStyle(subheader, icon='📈'):
    return f"""
        <div style='color:#fff000; font-size:1.8rem; 
        font-weight: bold; border-bottom: 3px solid;
        border-left: 3px solid; margin-bottom: 10px;
        display: inline-block; padding-left: 2px'>
            {icon}{subheader}
        </div>
    """
